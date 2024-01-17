package com.example.demo.config;

import javax.servlet.Filter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.config.annotation.SecurityConfigurerAdapter;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.DefaultSecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.filter.OncePerRequestFilter;

import com.example.demo.security.JwtTokenFilter;
import com.example.demo.security.JwtTokenProvider;

public class JwtConfigurer extends SecurityConfigurerAdapter<DefaultSecurityFilterChain, HttpSecurity> {

	   private final JwtTokenProvider jwtTokenProvider;

	    @Autowired
	    public JwtConfigurer(JwtTokenProvider jwtTokenProvider) {
	        this.jwtTokenProvider = jwtTokenProvider;
	    }

	    @Override
	    public void configure(HttpSecurity http) {
	        JwtTokenFilter customFilter = new JwtTokenFilter(this.jwtTokenProvider);
	        http.addFilterBefore((Filter) customFilter, UsernamePasswordAuthenticationFilter.class);
	    }

}

