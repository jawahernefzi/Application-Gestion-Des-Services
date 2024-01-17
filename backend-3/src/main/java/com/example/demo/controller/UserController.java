package com.example.demo.controller;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import com.example.demo.dto.MyUserDto;
import com.example.demo.model.Category;
import com.example.demo.model.MyUser;
import com.example.demo.model.Service;
import com.example.demo.service.UserServiceImp;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;

@Controller

@RequestMapping("/MyUser")
@CrossOrigin(origins = "http://localhost:53942") 

public class UserController {
@Autowired
	private UserServiceImp userService;
	

	
	@ModelAttribute("user")
    public MyUser user() {
        return new MyUser();
    }
	   @GetMapping("/secured-resource")
	    //@PreAuthorize("hasRole('user')")
	    public ResponseEntity<String> getSecuredResource() {
	        // Your code here
	        return ResponseEntity.ok("Access granted to secured resource!");
	    }
	
	   @PostMapping("addUser")
	   public ResponseEntity<?> registerUserAccount(@RequestBody MyUser user) {
		   MyUser registeredUser = userService.save(user);
	       System.out.println("User registered: " + registeredUser.toString());
	       // Return the registered user as JSON
	       return new ResponseEntity<>("the user "+registeredUser.getId()+" is registred successfully", HttpStatus.CREATED);
	   }
	   
	   
	   
	 //UpdateUser
	   @PutMapping("/{userId}")

	   public ResponseEntity<?> updateUser(@PathVariable Long userId, @RequestParam("user") String userJson,
	            @RequestParam("file") MultipartFile[] file,@RequestParam("profil") MultipartFile profil) {
	        return userService.updateUser(userId, userJson, file,profil);
	    }
	   
	   
	   
	   @PutMapping("/changeRole/{userId}")
	    public ResponseEntity<String> changeUserRole(@PathVariable Long userId) {
	        try {
	            userService.changeUserRole(userId);
	            return ResponseEntity.ok("User role changed successfully");
	        } catch (IllegalArgumentException e) {
	            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
	        }
	    }
	   
	   
	   
	   
	   
	   
	   
	   
	   
	 
	   
	
	   
	   

	   //deleteUser
	    @DeleteMapping("/deleteUser/{userId}")
	    public ResponseEntity<String> deleteUser(@PathVariable Long userId) {
	        userService.deleteUserById(userId);
	       
	        return  ResponseEntity.ok("deleted successfully");
	    }
//getUserbyid
	    @GetMapping("/{userId}")
	    @ResponseBody

	    public MyUserDto getUserById(@PathVariable Long userId) {
	        return 	   userService.getUserById(userId);

	    }
	    
	  //getUserbyEmail
	    @GetMapping("email/{email}")
	    @ResponseBody

	    public MyUserDto findByEmail(@PathVariable String email) {
	        return userService.findByEmail(email);

	    }   
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
//getALLusers
	    @GetMapping("/getUsers")
	    @ResponseBody

	    public List<MyUserDto> getUsers() {
	        return userService.getUsers();
	    }
	   
	   
	   
	   
	   
	   
	   
	   
	   

	   
	   


}