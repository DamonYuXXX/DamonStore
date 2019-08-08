package com.luckin.service.impl;

import com.luckin.dao.AdminDao;
import com.luckin.dao.entity.Admin;
import com.luckin.dao.entity.Permission;
import com.luckin.dao.entity.Role;
import com.luckin.service.AdminService;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

/**
 * @author Lilin Yu
 * @since 2019/08/01 11:12
 */

@Service(value = "adminDetailsService")
public class AdminDetailsServiceImpl implements AdminService {
    private final Logger logger = Logger.getLogger(AdminDetailsServiceImpl.class);
    @Autowired
    private AdminDao adminDao;
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Admin admin = adminDao.findValidAdminByUsername(username);
        List<Permission> permissions = adminDao.findPermissionByUsername(username);
        List<GrantedAuthority> authorities = new ArrayList<>();
        for (Permission permission: permissions) {
            GrantedAuthority authority = new SimpleGrantedAuthority(permission.getTag());
            authorities.add(authority);
            logger.info(permission.getTag());
        }
        admin.setAuthorities(authorities);
        //User user = new User("damon","{noop}1204578616",AuthorityUtils.commaSeparatedStringToAuthorityList("ROLE_USER"));
        return admin;
    }

    @Override
    public Integer createAdmin(Admin admin) {
        return adminDao.insert(admin);
    }

    @Override
    public Integer bindRole(BigInteger adminID, int roleID) {
        return adminDao.bindRole(adminID,roleID);
    }

    @Override
    public Integer updateAdmin(Admin admin) {
        return adminDao.update(admin);
    }

    @Override
    public Role findRoleByUsername(String username) {
        return adminDao.findRoleByUsername(username);
    }

    @Override
    public Admin findValidAdminByUsername(String username) {
        return adminDao.findValidAdminByUsername(username);
    }

    @Override
    public List<Admin> findAllAdmin() {
        return adminDao.findAllAdmin();
    }

    @Override
    public List<Role> findAllRole() {
        return adminDao.findAllRole();
    }
}
