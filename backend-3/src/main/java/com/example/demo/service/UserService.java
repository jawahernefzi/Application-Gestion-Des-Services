package com.example.demo.service;

import java.util.List;

import org.springframework.security.core.userdetails.UserDetailsService;

import com.example.demo.model.MyUser;



public interface UserService extends UserDetailsService{
	
	MyUser save(MyUser user);


}

