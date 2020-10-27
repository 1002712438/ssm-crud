package com.atguigu.crud.service.impl;

import com.atguigu.crud.mapper.EmployeeMapper;
import com.atguigu.crud.pojo.Employee;
import com.atguigu.crud.pojo.EmployeeExample;
import com.atguigu.crud.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author 风清扬
 * @date 2020/10/22 23:06
 */
@Service
public class EmployeeServiceImpl implements EmployeeService {
    @Autowired
    private EmployeeMapper employeeMapper;

//    @Override
//    public List<Employee> getEmps() {
//        return employeeMapper.selectByExample(null);
//    }

    @Override
    public List<Employee> getEmps() {
        return employeeMapper.selectByExampleWithDept(null);
    }

    @Override
    public void saveEmp(Employee employee) {
        employeeMapper.insertSelective(employee);
    }

    /**
     * @param name
     * @return true:用户名可用,false:用户名不可用
     */
    @Override
    public boolean checkUser(String name) {
        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        criteria.andEmpNameEqualTo(name);
        long count = employeeMapper.countByExample(example);
        return count == 0;
    }

    @Override
    public Employee getEmp(Integer id) {
        return employeeMapper.selectByPrimaryKey(id);
    }

    @Override
    public void updateEmp(Employee employee) {
        employeeMapper.updateByPrimaryKeySelective(employee);
    }

    @Override
    public void deleteEmp(Integer id) {
        employeeMapper.deleteByPrimaryKey(id);
    }

    @Override
    public void deleteEmpBatch(List<Integer> ids) {
        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        criteria.andEmpIdIn(ids);
        employeeMapper.deleteByExample(example);
    }
}
