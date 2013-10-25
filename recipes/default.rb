#
# Cookbook Name:: populate
# Recipe:: default
#
# Copyright (C) 2013 Florin STAN
#
# All rights reserved - Do Not Redistribute
#


node[:populate][:queries].each do |q|
  res = search(q[:index], q[:query]).map do |e|
    q[:fields].map do |f|
      if f[:append].nil?
        e[f[:name]]
      else
        "#{e[f[:name]]}#{f[:append]}"
      end
    end    
  end
  eval "#{q[:dest]} = res" unless res != nil
end