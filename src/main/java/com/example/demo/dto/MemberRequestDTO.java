package com.example.demo.dto;

import com.example.demo.domain.Member;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class MemberRequestDTO {
    private String loginId;
    private String password;
    private String name;

    public Member toEntity() {
        return new Member(loginId, password, name);
    }
}
