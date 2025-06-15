package com.example.livecommerce_server.member.dto;

import com.example.livecommerce_server.member.domain.Role;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MemberCreateDto {
    private String email;
    private String password;
    private String name;
    private Role role;
}
