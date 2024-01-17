package com.example.demo.dto;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ImageDto {
	 private Long id;

	    private String name;

	    private String type;
	    private String imagePath ;
		   private byte[] url ;

}
