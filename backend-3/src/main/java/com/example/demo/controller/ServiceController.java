package com.example.demo.controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
	import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;

import com.example.demo.dto.MyUserDto;
import com.example.demo.dto.ServiceDto;
import com.example.demo.model.Category;
import com.example.demo.model.ImageData;
import com.example.demo.model.MyUser;
import com.example.demo.model.Service;
import com.example.demo.repository.CategoryRepository;
import com.example.demo.repository.ServiceRepository;
import com.example.demo.security.JwtTokenProvider;
import com.example.demo.service.ImageService;
import com.example.demo.service.UserServiceImp;
import com.example.demo.util.ServiceUtil;
import com.example.demo.util.UserUtil;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Collection;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Set;

import javax.transaction.Transactional;


	@RestController
	@RequestMapping("/services")
	@CrossOrigin(origins = "http://localhost:53942") 

	public class ServiceController {

		@Autowired
	     private  ServiceRepository serviceRepository;
		@Autowired
		private  UserServiceImp userService;
		@Autowired
		private  CategoryRepository categoryRepository;
		 @Autowired
		private ObjectMapper objectMapper;
	    @Autowired
		 private ImageService imageDataService;

	    @Autowired  
	   private  JwtTokenProvider jwtTokenProvider;
		    
	    @Autowired  

	     private  ServiceUtil serviceUtil; 
		   @Autowired  
		     private  UserUtil userUtil ; 

		    
			//getUserServices

		    @GetMapping("/UserServices")
		    public List<ServiceDto> getAllUserServices(   @RequestHeader("Authorization") String authorizationHeader) {
		        List<Service> liste= serviceRepository.findAll();
		        List<ServiceDto> listeDto =new ArrayList<>();
	            String base64Credentials = authorizationHeader.substring("Basic".length()).trim();
	            String credentials = new String(Base64.getDecoder().decode(base64Credentials), StandardCharsets.UTF_8);
	            final String[] values = credentials.split(":", 2);
	            String email = values[0];
	              MyUserDto currentUser = userService.findByEmail(email);


	        Long    userId=currentUser.getId();
		       
		        for(Service service:liste)
		        {
		            if (service.getUser().getId().equals(userId)) {

			         ServiceDto   servicedto =serviceUtil.Convert(service);

		        	listeDto.add(servicedto); 
		        	}
		        }
		        return listeDto ;
		    }

		    
		    
		    
		    
		    
		    
		
		//getServices

		    
		    @GetMapping
		    public List<ServiceDto> getAllServices() {
		        List<Service> liste= serviceRepository.findAll();
		        List<ServiceDto> listeDto =new ArrayList<>();
		       
		        for(Service service:liste)
		        {
			         ServiceDto   servicedto =serviceUtil.Convert(service);

		        	listeDto.add(servicedto);
		        }
		        return listeDto ;
		        
		    }
		    
		    //getServiceById

		    @GetMapping("/{id}")
		    public ServiceDto getServiceById(@PathVariable Long id) {
		        
		            Service service = serviceRepository.findById(id)
		                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Service not found with id " + id));
		         ServiceDto   servicedto =serviceUtil.Convert(service);
		            return servicedto;
		      
		    }

//addService
		    @Transactional

		    @PostMapping("/addService")
		    public ResponseEntity<?> saveService(
		            @RequestParam("service") String serviceJson,
		          @RequestParam("images") MultipartFile[] images,
		            //@RequestHeader("Authorization") String token
		                   @RequestHeader("Authorization") String authorizationHeader

		    ) {

		        try {

		            Service service = objectMapper.readValue(serviceJson, Service.class);

		            service.setDate(new Date());
		         //   UserDetails userDetails = jwtTokenProvider.getUserDetailsFromToken(token);
		         /*   Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		      	  UserDetails userDetails =   (UserDetails) authentication.getPrincipal();
			        String email = userDetails.getUsername();
			        System.out.println("email"+email);*/
		            
		            
		            String base64Credentials = authorizationHeader.substring("Basic".length()).trim();
		            String credentials = new String(Base64.getDecoder().decode(base64Credentials), StandardCharsets.UTF_8);
		            final String[] values = credentials.split(":", 2);
		            String email = values[0];
		              MyUserDto userDto = userService.findByEmail(email);
		              MyUser currentUser=userUtil.convertToUser(userDto);
		            service.setUser(currentUser);
		            
			      
		            Service savedService = serviceRepository.save(service);
		            
		            savedService.setCategories(service.getCategories());

		           for (MultipartFile file : images) {
		               String result = imageDataService.uploadImageToFileSystem(file, savedService,null,false);
		               System.out.println(result);
		           }

		            return ResponseEntity.ok("Service saved successfully");
		        } catch (IOException e) {
		            // Handle exceptions appropriately (e.g., return an error response)
		            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error saving service");
		        }
		    }


		    
		    
		    
		    
				    
		    
//deleteService
		    @DeleteMapping("/{id}")
		    public ResponseEntity<String> deleteService(@PathVariable Long id) {
		        serviceRepository.deleteById(id);
		       return  ResponseEntity.ok("deleted successfully")	;	    }

//UpdateService
		    
		    @PutMapping("/{id}")
		    public ResponseEntity<?> updateService(@PathVariable Long id, @RequestParam("service") String serviceJson,
		    		@RequestParam("images") MultipartFile[] files)
 {
	            Service serviceUpdate = new Service();

		        Service service = serviceRepository.findById(id)
		                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Service not found with id " + id));
				try {
					serviceUpdate = objectMapper.readValue(serviceJson, Service.class);
				} catch (JsonMappingException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (JsonProcessingException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				//service.getCategories().clear();

	            service.setCategories(serviceUpdate.getCategories());

		        service.setTitre(serviceUpdate.getTitre());
		        service.setPrice(serviceUpdate.getPrice());
		        service.setDescription(serviceUpdate.getDescription());
		        service.setDetails(serviceUpdate.getDetails());
		        service.setDate(new Date());
		        service.setAdresse(serviceUpdate.getAdresse());

	            
					try {
						for (MultipartFile file : files) {
						String imageResponse = imageDataService.uploadImageToFileSystem(file, service,null,false)   ;
						}
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}

				

		        final Service updatedService = serviceRepository.save(service);
		        return ResponseEntity.ok("serviceUpdatet successfully");
		    }

		    
		    
		    
		    
		    
		    
		    //getServicesByCatgeory

		    @GetMapping("Category/{nom}")
		    public    List<ServiceDto> getServicesByCategory(@PathVariable String nom) {
		        
		            List<Service> services = serviceRepository.findAll();

	            	Set<Category> c = new  HashSet<>();
		            List<ServiceDto> servicesCat =new  ArrayList<>();
		            for(Service service:services)
		            {
							c=service.getCategories();
							for(Category cat:c)
							{
								if(cat.getName().equals(nom))
								{
							         ServiceDto   servicedto =serviceUtil.Convert(service);
										System.out.println("here");
							         servicesCat.add(servicedto);
									
								}
									
							}
							
		            }
		            return servicesCat;

		            	
		            }
		      
		    
		    
		    
	
	}


