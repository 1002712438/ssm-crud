package com.atguigu.crud;

import com.atguigu.crud.mapper.DepartmentMapper;
import com.atguigu.crud.mapper.EmployeeMapper;
import com.atguigu.crud.pojo.Department;
import com.atguigu.crud.pojo.Employee;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.sql.DataSource;
import java.sql.SQLException;
import java.util.UUID;

/**
 * @author 风清扬
 * @date 2020/10/21 23:12
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:applicationContext.xml")
public class SSMTest {
//    ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");

    @Autowired
    private DataSource dataSource;
    @Autowired
    private DepartmentMapper departmentMapper;
    @Autowired
    private EmployeeMapper employeeMapper;
    @Autowired
    private SqlSession sqlSession;

    @Test
    public void testDataSource() throws SQLException {
        System.out.println(dataSource.getConnection());
    }

    @Test
    public void testAdd_dept() {
        System.out.println(departmentMapper);
        // 向部门表插入几条数据
//        Department dept1 = new Department();
//        dept1.setDeptName("开发部");
//        Department dept2 = new Department();
//        dept2.setDeptName("测试部");
//        departmentMapper.insertSelective(dept1);
//        departmentMapper.insertSelective(dept2);
        departmentMapper.insertSelective(new Department(null, "开发部"));
        departmentMapper.insertSelective(new Department(null, "测试部"));


    }

    @Test
    public void testAdd_emp() {
        // 向员工表插入数据
        employeeMapper.insertSelective(new Employee(null, "jerry", "F", "jerry@atguigu.com", 6));
        employeeMapper.insertSelective(new Employee(null, "tom", "M", "tom@atguigu.com", 7));
    }

    @Test
    public void testAdd_emp_batch() {
        // 向员工表插入数据(批量插入)
        String name;
        String gender;
        int deptId;
        for (int i = 0; i < 1000; i++) {
            name = UUID.randomUUID().toString().substring(0, 5);
            if (i % 2 == 0) {
                gender = "M";
                deptId = 6;
            } else {
                gender = "F";
                deptId = 7;
            }
            EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
            mapper.insertSelective(new Employee(null, name, gender, name + "@atguigu.com", deptId));
        }
    }
}
