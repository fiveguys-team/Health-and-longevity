package com.example.livecommerce_server.member.domain;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Member {
    private Long userId;
    private String email;
    private String password;
    private String name;
    private String interest;
    private String socialId;
    private SocialType socialType;
    private Role role;
    private boolean emailVerified;
}
