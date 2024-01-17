package com.example.demo.model;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;


@Entity
@Table(name = "imageData")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ImageData {
	
	    @Id
	    @GeneratedValue(strategy = GenerationType.IDENTITY)
	    private Long id;

	    private String name;

	    private String type;
	   
	    @Lob
	    @Column(name = "imagedata", length = 1000)
	    private String imagePath ;
	    
		   private byte[] url ;

	    @ManyToOne
	    @JoinColumn(name = "service_id")
	    private Service service;
	 
	    @ManyToOne
	    @JoinColumn(name = "user_id")
	    private MyUser user;
	
}
