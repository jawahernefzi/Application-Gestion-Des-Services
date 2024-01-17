package com.example.demo.model;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@Setter
@Getter
@Entity
@Table(name="Services")
public class Service {
		 @Id
		    @GeneratedValue(strategy = GenerationType.IDENTITY)
		    @Column(name = "id_service")
		    private Long idService;

		    @Column(name = "titre")
		    private String titre;

		    @Column(name = "price")
		    private Float price;

		    @Column(name = "description")
		    private String description;

		    @Column(name = "details")
		    private String details;

		    @Temporal(TemporalType.TIMESTAMP)
		    @Column(name = "date")
		    private Date date;


		    @Column(name = "adresse")
		    private String adresse;
		    
		    @OneToMany(mappedBy = "service", cascade = CascadeType.ALL)
		    private Set<ImageData> images;
		    
		   @ManyToOne
		    @JoinColumn(name = "user_id")
		    private MyUser user;
		   @ManyToMany
		    @JoinTable(
		        name = "service_category",
		        joinColumns = @JoinColumn(name = "service_id"),
		        inverseJoinColumns = @JoinColumn(name = "category_id"))
		    private Set<Category> categories = new HashSet<>();
		    


		@Override
		public String toString() {
			return "Service [idService=" + idService + ", titre=" + titre + ", price=" + price + ", description="
					+ description + ", details=" + details + ", date=" + date + ", adresse=" + adresse + "]";
		}

		
	

	

}
