package com.atguigu.crud;

import com.atguigu.crud.pojo.Employee;
import com.github.pagehelper.PageInfo;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;

/**
 * 使用spring测试模块提供的测试请求功能,测试crud请求的正确性
 *
 * @author 风清扬
 * @date 2020/10/23 20:18
 */
@WebAppConfiguration
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml", "classpath:spring-mvc.xml"})
public class MVCTest {
    //虚拟mvc请求,获取到处理结果
    MockMvc mockMvc;
    //传入spring mvc的ioc容器
    @Autowired
    WebApplicationContext context;

    @Before
    public void initMockMvc() {
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();

    }

    @Test
    public void testPage() throws Exception {
        //模拟请求获取返回值
        MvcResult result = mockMvc.perform(MockMvcRequestBuilders
                .get("/emps")
                .param("pn", "1")
                .param("ps", "5")).andReturn();
        //请求成功以后我们可以从请求域中获取pageInfo对象进行验证
        MockHttpServletRequest request = result.getRequest();
        PageInfo pageInfo = (PageInfo) request.getAttribute("pageInfo");
        System.out.println("当前页码:" + pageInfo.getPageNum());
        System.out.println("总页码:" + pageInfo.getPages());
        System.out.println("总记录数:" + pageInfo.getTotal());
        System.out.println("在页面需要连续显示的页码:");
        for (int num : pageInfo.getNavigatepageNums()) {
            System.out.println(num);
        }
        //获取员工数据
        List<Employee> list = pageInfo.getList();
        for (Employee employee : list) {
            System.out.println("ID:" + employee.getEmpId() + "\tName:" + employee.getEmpName());
        }
    }
}
