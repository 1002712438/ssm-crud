package com.atguigu.crud.service;

import com.atguigu.crud.pojo.Employee;

import java.util.List;

/**
 * @author 风清扬
 * @date 2020/10/22 22:53
 */
public interface EmployeeService {
    /**
     * 查询所有员工信息
     *
     * @return
     */
    List<Employee> getEmps();

    /**
     * 保存员工
     *
     * @param employee
     */
    void saveEmp(Employee employee);

    /**
     * 检验用户名是否可用
     * @param name
     * @return
     */
    boolean checkUser(String name);

    /**
     * 根据id查询员工
     * @param id
     * @return
     */
    Employee getEmp(Integer id);

    void updateEmp(Employee employee);

    void deleteEmp(Integer id);

    void deleteEmpBatch(List<Integer> ids);
}
