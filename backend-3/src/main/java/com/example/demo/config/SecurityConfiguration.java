package com.example.demo.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import com.example.demo.security.JwtTokenProvider;
import com.example.demo.service.UserService;

@Configuration
@EnableWebSecurity
public class SecurityConfiguration extends WebSecurityConfigurerAdapter {

	@Autowired
    private UserService userService;
    @Autowired
    private BCryptPasswordEncoder passwordEncoder;
	private UserDetailsService userDetailsService;
	private JwtTokenProvider jwtTokenProvider;
  
	 @Bean
	    public JwtConfigurer jwtConfigurer(JwtTokenProvider jwtTokenProvider) {
	        return new JwtConfigurer(jwtTokenProvider);
	    }
    @Bean
    public BCryptPasswordEncoder bCryptPasswordEncoder() {
        return new BCryptPasswordEncoder();
    }
    public SecurityConfiguration(UserDetailsService userDetailsService, JwtTokenProvider jwtTokenProvider) {
        this.userDetailsService = userDetailsService;
        this.jwtTokenProvider = jwtTokenProvider;
    }
    @Bean
    @Override
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }
    
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
                .antMatchers("/MyUser","/MyUser/{userId}","/api/auth","/services/**","/services/{id}","/image/info/{Name}","/image/{Name}","/image/upload","/services/addService"
                		,"/services/UserServices" ,"/MyUser/**","/image/**","/api/categories").permitAll()
                .anyRequest().authenticated()
                .and()
                .apply(new JwtConfigurer(this.jwtTokenProvider))
                .and()
            .logout()
                .logoutUrl("/logout")
                .logoutSuccessUrl("/login?logout") // you can customize the redirect URL
                .invalidateHttpSession(true)
                .clearAuthentication(true)
                .deleteCookies("JSESSIONID")
            .and()
            .csrf().disable();
    }



    @Bean
    public DaoAuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userService);
        authProvider.setPasswordEncoder(passwordEncoder);
        return authProvider;
    }


}
