package com.example.demo.util;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.example.demo.dto.CategoryDto;
import com.example.demo.dto.ImageDto;
import com.example.demo.dto.MyUserDto;
import com.example.demo.dto.ServiceDto;
import com.example.demo.model.Category;
import com.example.demo.model.ImageData;
import com.example.demo.model.Service;
import com.example.demo.service.ImageService;
@Component

public  class ServiceUtil {
	 private final ImageService imageService;

	    @Autowired
	    public ServiceUtil(ImageService imageService) {
	        this.imageService = imageService;
	    }
	
 	public  ServiceDto Convert (Service service)
	{
		
		Long id=service.getIdService();
        ServiceDto servicedto=new ServiceDto();
          List  <ImageDto> imagedto= new ArrayList <>();
          List  <CategoryDto> categorydto= new ArrayList <>();
            MyUserDto userdto=new MyUserDto();
            
            
            
            
            //service
            servicedto.setIdService(id);
            servicedto.setTitre(service.getTitre());
            servicedto.setPrice(service.getPrice());
            servicedto.setAdresse(service.getAdresse());
            servicedto.setDescription(service.getDescription());
            servicedto.setDetails(service.getDetails());
            servicedto.setDate(service.getDate());
            
//image
for (ImageData image : service.getImages()) {

    try {                                           
    	ImageDto	imageDto=new ImageDto();    
    	
    	// Download the image data
        byte[] imageData =imageService.downloadImageFromFileSystem(image.getName());
System.out.println(imageData);
        
   imageDto.setUrl(imageData);
        imageDto.setImagePath(image.getImagePath());
        imageDto.setName(image.getName());
        imageDto.setType(image.getType());
        imagedto.add(imageDto);
    } catch (IOException e) {
        // Handle the exception if there's an issue reading the image data
        e.printStackTrace();
    }
}
            servicedto.setImages(imagedto);

            //user
            userdto.setId(service.getUser().getId());
            userdto.setFirstName(service.getUser().getFirstName());
            userdto.setLastName(service.getUser().getLastName());
            userdto.setEmail(service.getUser().getEmail());
            userdto.setDiplome(service.getUser().getDiplome());
            userdto.setAdresseDomicile(service.getUser().getAdresseDomicile());
            userdto.setAdresseTravail(service.getUser().getAdresseTravail());
            userdto.setTel(service.getUser().getTel());
            
           servicedto.setUser(userdto);
           //categories
           for(Category  category :service.getCategories()  )
           {
        	   categorydto.add(new CategoryDto(category.getId(), category.getName())) ;      
           	
           }
           servicedto.setCategory(categorydto);

		
	
	
	
	
	
	
return servicedto;

	
	
}
}
