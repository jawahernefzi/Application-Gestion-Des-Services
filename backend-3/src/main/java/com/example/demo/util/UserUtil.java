package com.example.demo.util;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.example.demo.dto.CategoryDto;
import com.example.demo.dto.ImageDto;
import com.example.demo.dto.MyUserDto;
import com.example.demo.dto.RoleDto;
import com.example.demo.model.Category;
import com.example.demo.model.ImageData;
import com.example.demo.model.MyUser;
import com.example.demo.model.Role;
import com.example.demo.service.ImageService;
@Component
public  class UserUtil {
	 private final ImageService imageService;
	    @Autowired
	    public UserUtil(ImageService imageService) {
	        this.imageService = imageService;
	    }
	
	public  MyUserDto convert(MyUser user) {
	    MyUserDto userDto = new MyUserDto();
	    userDto.setId(user.getId());
	    userDto.setFirstName(user.getFirstName());
	    userDto.setLastName(user.getLastName());
	    userDto.setEmail(user.getEmail());
	    userDto.setDiplome(user.getDiplome());
	    userDto.setAdresseDomicile(user.getAdresseDomicile());
	    userDto.setAdresseTravail(user.getAdresseTravail());

	    userDto.setTel(user.getTel());
	    RoleDto r=new RoleDto(user.getRole().getId(), user.getRole().getName());
	    userDto.setRole(r);
        
//image
        List  <ImageDto> imagedto= new ArrayList <>();

for (ImageData image : user.getImages()) {

	
try {                                           
	ImageDto	imageDto=new ImageDto();    
	
	// Download the image data
    byte[] imageData =imageService.downloadImageFromFileSystem(image.getName());
System.out.println(imageData);
    
imageDto.setUrl(imageData);
    imageDto.setName(image.getName());
    imageDto.setImagePath(image.getImagePath());
    imagedto.add(imageDto);
} catch (IOException e) {
    // Handle the exception if there's an issue reading the image data
    e.printStackTrace();
}
}
        userDto.setImages(imagedto);
	        
	    // set categories if needed
	    List<CategoryDto> categorydto=new ArrayList<>();
        for(Category  category :user.getCategories()  )
        {
     	   categorydto.add(new CategoryDto(category.getId(), category.getName())) ;      
        	
        }
        userDto.setCategory(categorydto);      

	    return userDto;
	}

	
	
	
	//from userDTo to user
	 public MyUser convertToUser(MyUserDto userDto) {
	        MyUser user = new MyUser();
	        user.setId(userDto.getId());
	        user.setFirstName(userDto.getFirstName());
	        user.setLastName(userDto.getLastName());
	        user.setEmail(userDto.getEmail());
	        user.setDiplome(userDto.getDiplome());
	        user.setAdresseDomicile(userDto.getAdresseDomicile());
	        user.setAdresseTravail(userDto.getAdresseTravail());
	        user.setTel(userDto.getTel());
		    Role r=new Role(userDto.getRole().getId(), userDto.getRole().getName());
		    
		    	    user.setRole(r);
		            
	        // Images
	        Set<ImageData> imageList = new HashSet<>();
	        for (ImageDto imageDto : userDto.getImages()) {
	            ImageData imageData = new ImageData();
	            imageData.setName(imageDto.getName());
	            imageData.setImagePath(imageDto.getImagePath());

				try {
					 byte[] 	url = imageService.downloadImageFromFileSystem(imageDto.getName());
			            imageData.setUrl(url);

				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

	            // You may need to handle the conversion of image data to a byte array here
	            // imageData.setData(imageDto.getUrl());
	            imageList.add(imageData);
	        }
	        user.setImages(imageList);        

	        // Categories
	        Set<Category> categoryList = new HashSet<>();
	        for (CategoryDto categoryDto : userDto.getCategory()) {
	            Category category = new Category();
	            category.setId(categoryDto.getId());
	            category.setName(categoryDto.getName());
	            categoryList.add(category);
	        }
	        user.setCategories(categoryList);

	        return user;
	    }
	
	
	
	
	
	
	
	
	
	
	
}
