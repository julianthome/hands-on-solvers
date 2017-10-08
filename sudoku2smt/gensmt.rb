#!/usr/bin/env ruby
# 
# Generate SMT constraint from Sudoku puzzle
#
# The MIT License (MIT)
#
# Copyright (c) 2017 Julian Thome <julian.thome.de@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# 

require 'csv'

dim=9
x=0
subdim=3
clausenum=0

ifile=ARGV.first

setting=""

$vmap = {}
$vid = 1
var = []

def lookup(v)
    return "v" + v[0].to_s + v[1].to_s
end

vardecl=""

# generate all possible variable assignments
(0..dim-1).each do |x| # iterate over rows
     (0..dim-1).each do |y| # iterate over columns
        var << [x,y] 
        vardecl += "(declare-fun " + lookup([x,y]).to_s + "() Int)\n"
    end
end


# read the input file
CSV.foreach(ifile) do |row|
    (0..row.length-1).each do |y| 
        if row[y] != nil
            setting += "(assert (= " + lookup([x,y]).to_s + "  " + row[y].to_s + "))\n"
        end
    end
    x+=1
end


# row constraint
rowcon=""
# column constraints
colcon=""
# available numbers per cell
allnums=""
# only pick one number per cell
onlynums=""

var.each do |v|
    comp = lookup([v[0],v[1]]).to_s
    vcolcon="(assert (distinct " + comp + " " 
    (0..dim-1).each do |x|
        if x == v[0]
            next
        end
        vcolcon += lookup([x,v[1]]).to_s + " "
    end
    vcolcon+="))\n";
    vrowcon="(assert (distinct " + comp + " " 
    (0..dim-1).each do |y|
        if y == v[1]
            next
        end
        vrowcon += lookup([v[0],y]).to_s + " "
    end
    vrowcon += "))\n"
    onlynums += "(assert (<= " + lookup(v).to_s + " " + dim.to_s + "))\n"
    onlynums += "(assert (> " + lookup(v).to_s + " " + (0).to_s + "))\n"

    colcon += vcolcon
    rowcon += vrowcon
end


segments = []
segmentstr = ""

(0..subdim-1).each do |xof|
    (0..subdim-1).each do |yof|
        xoff=xof*subdim
        yoff=yof*subdim
        subsegments = []
        (0+xoff..subdim-1+xoff).each do |x|
            (0+yoff..subdim-1+yoff).each do |y|
                subsegments << [x,y]
            end
        end

        segtmp="(assert (distinct "
        subsegments.each do |t|
            segtmp += lookup(t) + " "
        end
        segtmp+="))\n"
        segmentstr += segtmp
    end
end



final = "(set-option :produce-models true)\n" + 
    vardecl + setting + rowcon + colcon + segmentstr + onlynums +
    "\n(check-sat)\n(get-model)"

cfile=open(File.basename(ifile,".csv") + ".smt2",'w')
cfile.write(final)
cfile.close()
