#!/usr/bin/env ruby
# 
# Generate DIMACS constraint from Sudoku puzzle
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

def neg(t1,t2) 
    return "-" + t1 + " -" + t2 + " 0\n"
end

def lookup(x,y,z)
    return $vmap[compkey([x,y,z])];
end

def compkey(v) 
    return v[0].to_s + v[1].to_s + v[2].to_s
end


# generate all possible variable assignments
(0..dim-1).each do |x| # iterate over rows
     (0..dim-1).each do |y| # iterate over columns
        (0..dim-1).each do |z| 
            var << [x,y,z] 
        end
    end
end


vsmap=""

# remap variables to natural numbers
var.each do |v|
    # puts "v" + v[0].to_s + " " + v[1].to_s + " " + v[2].to_s
    $vmap[compkey(v)] = $vid
    vsmap += $vid.to_s + "," + v[0].to_s + "," + v[1].to_s + "," + (v[2]+1).to_s + "\n"
    $vid+=1
end


# read the input file
CSV.foreach(ifile) do |row|
    (0..row.length-1).each do |y| 
        if row[y] != nil
            setting += lookup(x,y,row[y].to_i-1).to_s + "  0\n"
            clausenum +=1
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
    comp = lookup(v[0],v[1],v[2]).to_s
    (0..dim-1).each do |x|
        if x == v[0]
            next
        end
        colcon += neg(comp,lookup(x,v[1],v[2]).to_s)
        clausenum +=1
    end
    (0..dim-1).each do |y|
        if y == v[1]
            next
        end
        rowcon += neg(comp, lookup(v[0],y,v[2]).to_s)
        clausenum +=1
    end
    allnumstmp = ""
    (0..dim-1).each do |z|
        if z == v[2]
            next
        end
        onlynums += neg(comp,lookup(v[0],v[1],z).to_s)
        clausenum +=1
        if allnumstmp.length > 0
            allnumstmp += " "
        end
        allnumstmp += comp + " " + lookup(v[0],v[1],z).to_s
    end
    allnums += allnumstmp + " 0\n"
    clausenum +=1
end


segments = []
segmentstr = ""

(0..subdim-1).each do |xof|
    (0..subdim-1).each do |yof|
        xoff=xof*subdim
        yoff=yof*subdim
        (0..dim-1).each do |z|
            subsegments = []
            (0+xoff..subdim-1+xoff).each do |x|
                (0+yoff..subdim-1+yoff).each do |y|
                    subsegments << [x,y,z]
                end
            end
            segments << subsegments 
        end
    end
end


segments.each do |segment|
    segment.each do |ofield|
        comp = lookup(ofield[0],ofield[1],ofield[2]).to_s
        segment.each do |ifield|
            if ofield == ifield
                next
            end
            segmentstr += neg(comp, lookup(ifield[0],ifield[1],ifield[2]).to_s)
            clausenum +=1
        end
    end
end

final = "p cnf " + clausenum.to_s + " " + ($vid-1).to_s + "\n" +  setting +
    rowcon + colcon + segmentstr + onlynums + allnums

cfile=open(File.basename(ifile,".csv") + ".cnf",'w')
vfile=open(File.basename(ifile,".csv") + ".vmap",'w')

cfile.write(final)
vfile.write(vsmap)

cfile.close()
vfile.close()
