package com.example.demo.dto;

import java.util.Date;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ServiceDto {

    private Long idService;
    private String adresse;
    private Date date;
    private String details;
    private String description;
    private Float price;
    private String titre;
    private List<ImageDto> images ;
	private MyUserDto user ;
	private List<CategoryDto>  category;
	
	
}
