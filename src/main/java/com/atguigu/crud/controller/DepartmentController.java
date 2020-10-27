package com.atguigu.crud.controller;

import com.atguigu.crud.pojo.Department;
import com.atguigu.crud.service.DepartmentService;
import com.atguigu.crud.utils.Msg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * 处理和部门有关的请求
 *
 * @author 风清扬
 * @date 2020/10/24 18:53
 */
@Controller
public class DepartmentController {
    @Autowired
    private DepartmentService departmentService;

    /**
     * 返回所有的部门信息
     * @return
     */
    @ResponseBody
    @RequestMapping("depts")
    public Msg getDepts() {
        List<Department> departmentList = departmentService.getDepts();
        return Msg.success().add("depts", departmentList);
    }
}
