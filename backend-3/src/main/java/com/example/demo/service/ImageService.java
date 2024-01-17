package com.example.demo.service;

import com.example.demo.model.ImageData;
import com.example.demo.model.MyUser;
import com.example.demo.repository.ImageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;


@Service
public class ImageService {

    @Autowired
    private ImageRepository imageRepository ;
    
    private final String FOLDER_PATH="C:/isetrades/semestre5/projet_dintegration/servicesProject/backend-3/images/";
 
    public String uploadImageToFileSystem(MultipartFile file, com.example.demo.model.Service service, MyUser user,Boolean isProfile) throws IOException {
        String originalFilename = file.getOriginalFilename();
        String fileExtension = getFileExtension(originalFilename);

        // Générer un nom de fichier aléatoire avec UUID
        String randomFileName = UUID.randomUUID().toString() + fileExtension;
String name=isProfile? "profile" + randomFileName : randomFileName ;
        String filePath = FOLDER_PATH +name;
        if (isProfile) {
            deleteProfileImage(user);
        }
        ImageData fileData = imageRepository.save(ImageData.builder()
                .name(name)
                .type(file.getContentType())
                .imagePath(filePath)
                .service(service)
                .user(user)
                .build());
        file.transferTo(new File(filePath));

        if (fileData != null) {
            return "Fichier téléchargé avec succès : " + filePath;
        }
        return null;
    }

  

	private String getFileExtension(String filename) {
        int dotIndex = filename.lastIndexOf(".");
        if (dotIndex > 0) {
            return filename.substring(dotIndex);
        }
        return "";
    }
    
 

    public byte[] downloadImageFromFileSystem(String fileName) throws IOException {
        Optional<ImageData> fileData =  imageRepository.findByName(fileName);     
        String filePath=fileData.get().getImagePath();
        
        
        
        byte[] images = Files.readAllBytes(new File(filePath).toPath());
        return images;
    }

	
    
    
    
    
    

    private void deleteProfileImage(MyUser user) {
        Set<ImageData> images = user.getImages();
        ImageData imageToDelete = null;

        for (ImageData image : images) {
            if (image.getName().startsWith("profile")) {
                File fileToDelete = new File(image.getImagePath());

                if (fileToDelete.exists()) {
                    if (fileToDelete.delete()) {
                        System.out.println("Profile image file deleted: " + image.getImagePath());
                        imageToDelete = image;
                        break;  // Found the profile image, no need to continue
                    } else {
                        System.out.println("Failed to delete profile image file.");
                    }
                } else {
                    System.out.println("Profile image file not found: " + image.getImagePath());
                }
            }
        }

        if (imageToDelete != null) {
            images. remove(imageToDelete);
            imageRepository.delete(imageToDelete);
            System.out.println("Profile image deleted from the database.");
        }
    }
    
    
    
    
    
  
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    



    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
   

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


  
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
  

}
