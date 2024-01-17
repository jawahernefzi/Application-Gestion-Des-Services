package com.example.demo;

import com.example.demo.controller.UserController;
import com.example.demo.dto.MyUserDto;
import com.example.demo.model.MyUser;
import com.example.demo.service.UserServiceImp;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MultipartFile;

import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

class UserControllerTest {

    @Mock
    private UserServiceImp userService;

    @InjectMocks
    private UserController userController;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }
/*
    @Test
    void registerUserAccountTest() {
        MyUser user = new MyUser();
        user.setEmail("test@example.com");
        when(userService.save(any())).thenReturn(user);

        ResponseEntity<?> response = userController.registerUserAccount(user);

        assertEquals(HttpStatus.CREATED, response.getStatusCode());
        assertEquals("the user " + user.getId() + " is registred successfully", response.getBody());
    }*/

    @Test
    void updateUserTest() {
        Long userId = 1L;
        String userJson = "{\"firstName\":\"John\",\"lastName\":\"Doe\",\"diplome\":\"PhD\"}";
        MultipartFile[] files = new MultipartFile[2];
        ResponseEntity<String> expectedResponse = ResponseEntity.ok("User updated successfully");

        // Correct the stubbing to use isNull() for the files parameter
        doReturn(expectedResponse)
            .when(userService)
            .updateUser(eq(userId), eq(userJson), eq(files), isNull());

        ResponseEntity<?> response = userController.updateUser(userId, userJson, files, null);

        assertEquals(expectedResponse, response);
    }



   /* @Test
    void deleteUserTest() {
        Long userId = 1L;
        ResponseEntity<String> expectedResponse = ResponseEntity.ok("deleted successfully");
        when(userService.deleteUserById(userId)).thenReturn(expectedResponse.getBody());

        ResponseEntity<String> response = userController.deleteUser(userId);

        assertEquals(expectedResponse, response);
    }*/

  /*  @Test
    void getUserByIdTest() {
        Long userId = 1L;
        MyUserDto expectedUserDto = new MyUserDto();
        when(userService.getUserById(userId)).thenReturn(expectedUserDto);

        MyUserDto userDto = userController.getUserById(userId);

        assertEquals(expectedUserDto, userDto);
    }

    @Test
    void findByEmailTest() {
        String email = "test@example.com";
        MyUserDto expectedUserDto = new MyUserDto();
        when(userService.findByEmail(email)).thenReturn(expectedUserDto);

        MyUserDto userDto = userController.findByEmail(email);

        assertEquals(expectedUserDto, userDto);
    }
    */
/*
    @Test
    void getUsersTest() {
        List<MyUserDto> expectedUsers = Collections.singletonList(new MyUserDto());
        when(userService.getUsers()).thenReturn(expectedUsers);

        List<MyUserDto> users = userController.getUsers();

        assertEquals(expectedUsers, users);
    }*/
}
