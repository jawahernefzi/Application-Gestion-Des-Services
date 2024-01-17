package com.example.demo.dto;
import java.util.List;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MyUserDto {
    private Long id;
    private String firstName;
    private String adresseTravail ;
    private String adresseDomicile ;
	private String diplome ;
	   private String tel   ;
	    private String password;
	    private String email;
	    private String lastName;
		private List<CategoryDto>  category;
		private List<ServiceDto>  services;
	  private List<ImageDto> images ;
private RoleDto role ;

}
