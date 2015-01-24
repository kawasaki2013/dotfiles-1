#!/usr/bin/env ruby

def test_deploy
    c=0
    list = []
    Dir.chdir("../..") {
        if File.exists?("Makefile")
            `make deploy`
            make_list = `make list 2>&1`
            exit 1 unless $? == 0

            list = make_list.rstrip.split(/\r?\n/).map {|line| line.chomp }
            list.each {|f|
                source = File.expand_path(f)
                dest = File.expand_path(ENV["HOME"] + "/" + f)
                if File.symlink?(dest) then
                    c += 1 if File.readlink(dest) == source
                end
            }

            exit 1 unless c == list.length
        else
            exit 1
        end
    }

end

test_deploy