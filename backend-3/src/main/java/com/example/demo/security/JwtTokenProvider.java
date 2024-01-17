package com.example.demo.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.InvalidKeyException;
import io.jsonwebtoken.security.Keys;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import com.example.demo.model.MyUser;
import com.example.demo.service.UserServiceImp;

import javax.servlet.http.HttpServletRequest;
import java.security.Key;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

@Component
@PropertySource("classpath:application.properties")
public class JwtTokenProvider {

    private  String secret="yourBase64EncodedSecretKey";
    @Autowired
    private UserServiceImp userService;
    private  Long expiration=230000L;

    private final Key key;
 

    public JwtTokenProvider( ) {
        this.secret = secret.trim();
        this.key = Keys.secretKeyFor(SignatureAlgorithm.HS512);
    }
   
    public String generateToken(Authentication authentication) {
        UserDetails userDetails =  (UserDetails) authentication.getPrincipal();
        String email = userDetails.getUsername();



            // Get the user ID (assuming you have a method to retrieve it from the user details)
            Long userId = userService.findByEmail(email).getId() ; 

            Map<String, Object> claims = new HashMap<>();
            claims.put("userId", userId);

            return createToken( claims,email);
    }


    private String createToken(Map<String, Object> claims, String subject) {

    	
    	Date now = new Date();
        
        Date expirationDate = new Date(now.getTime() + (1000 * 60 * 60 * 24));


        return Jwts.builder()
                .setClaims(claims)
                .setSubject(subject)
                .setIssuedAt(now)
                .setExpiration(expirationDate)
                .signWith(key, SignatureAlgorithm.HS512)
                .compact();
    }

   
    public Boolean validateToken(String token) {
        return !isTokenExpired(token);
    }

    public Authentication getAuthentication(String token) {
        UserDetails userDetails = getUserDetailsFromToken(token);
        return new UsernamePasswordAuthenticationToken(userDetails, "", userDetails.getAuthorities());
    }

    public String resolveToken(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
        	
        	System.out.println("brear" + bearerToken);
        

        	String token = bearerToken.substring("Bearer ".length()).trim();
        	
            System.out.println(token);
                    	
        	
            return token;

        }
        return null;
    }

    public UserDetails getUserDetailsFromToken(String token) {
        Claims claims = getAllClaimsFromToken(token);
        String email = claims.getSubject();

        // Retrieve the userId claim
        Long userId = claims.get("userId", Long.class);

        // Create authorities as needed
        List<GrantedAuthority> authorities = new ArrayList<>();

        return new User(email, "", authorities);
    }


    private Claims getAllClaimsFromToken(String token) {
    	 
    	
        return Jwts.parser().setSigningKey(key).parseClaimsJws(token).getBody();
    }

    private Boolean isTokenExpired(String token) {
        final Date expiration = getExpirationDateFromToken(token);
        return expiration.before(new Date());
    }

    public Date getExpirationDateFromToken(String token) {
        return getClaimFromToken(token, Claims::getExpiration);
    }

    private <T> T getClaimFromToken(String token, Function<Claims, T> claimsResolver) {
        Claims claims = getAllClaimsFromToken(token);
        return claimsResolver.apply(claims);
    }
}
