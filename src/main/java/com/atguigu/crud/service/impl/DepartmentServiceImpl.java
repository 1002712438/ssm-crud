package com.atguigu.crud.service.impl;

import com.atguigu.crud.mapper.DepartmentMapper;
import com.atguigu.crud.pojo.Department;
import com.atguigu.crud.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author 风清扬
 * @date 2020/10/24 19:38
 */
@Service
public class DepartmentServiceImpl implements DepartmentService {
    @Autowired
    private DepartmentMapper departmentMapper;

    @Override
    public List<Department> getDepts() {
        return departmentMapper.selectByExample(null);
    }
}
