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
		if q[:fields].kind_of? String 
			e[q[:fields]]
		elsif q[:fields].class.to_s.contains? "Array"
			q[:fields].map { |f| e[f] }			
		end
	end 
	eval "#{q[:dest]} = res" unless res != nil
end