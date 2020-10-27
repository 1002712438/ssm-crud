package com.atguigu.crud.controller;

import com.atguigu.crud.pojo.Employee;
import com.atguigu.crud.service.EmployeeService;
import com.atguigu.crud.utils.Msg;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 处理和员工有关的请求
 *
 * @author 风清扬
 * @date 2020/10/22 22:53
 */
@Controller
public class EmployeeController {
    @Autowired
    private EmployeeService employeeService;

    /**
     * 查询员工列表(普通请求)
     *
     * @param pageNum  当前页码
     * @param pageSize 每页显示的条数
     * @param model    模型对象,将数据存放到request域中
     * @return
     */
    @RequestMapping("emps")
    public String toEmpListPage(@RequestParam(value = "pn", defaultValue = "1") Integer pageNum,
                                @RequestParam(value = "ps", defaultValue = "10") Integer pageSize,
                                Model model) {
        PageHelper.startPage(pageNum, pageSize);
        List<Employee> employeeList = employeeService.getEmps();
        PageInfo<Employee> pageInfo = new PageInfo<>(employeeList, 5);
        model.addAttribute("pageInfo", pageInfo);
        return "list";
    }

    /**
     * 查询员工列表(ajax请求)
     *
     * @param pageNum  当前页码
     * @param pageSize 每页显示的条数
     * @return
     */
    @RequestMapping("emps2")
    @ResponseBody
    public PageInfo<Employee> toEmpListReturnJson(@RequestParam(value = "pn", defaultValue = "1") Integer pageNum,
                                                  @RequestParam(value = "ps", defaultValue = "10") Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Employee> employeeList = employeeService.getEmps();
        PageInfo<Employee> pageInfo = new PageInfo<>(employeeList, 5);
        return pageInfo;
    }

    //统一返回结果
    @RequestMapping("emps3")
    @ResponseBody
    public Msg toEmpList(@RequestParam(value = "pn", defaultValue = "1") Integer pageNum,
                         @RequestParam(value = "ps", defaultValue = "5") Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Employee> employeeList = employeeService.getEmps();
        PageInfo<Employee> pageInfo = new PageInfo<>(employeeList, 5);
        return Msg.success().add("pageInfo", pageInfo);
    }

    /**
     * JSR303数据校验:
     * 1.导入hibernate-validator坐标
     * 2.实体类加入相应注解和正则表达式
     * 3.封装时加入@Valid注解,BindingResult对象
     * <p>
     * 保存员工
     *
     * @param employee
     * @return
     */
    @RequestMapping(value = "addEmp", method = RequestMethod.POST)
    @ResponseBody
    public Msg addEmp(@Valid Employee employee, BindingResult result) {
        //校验失败则不进行保存,返回错误消息
        if (result.hasErrors()) {
            Map<String, Object> map = new HashMap<>();
            List<FieldError> fieldErrors = result.getFieldErrors();
            for (FieldError fieldError : fieldErrors) {
                System.out.println("错误的字段名:" + fieldError.getField());
                System.out.println("错误信息:" + fieldError.getDefaultMessage());
                map.put(fieldError.getField(), fieldError.getDefaultMessage());
            }
            return Msg.fail().add("errorFiled", map);
        } else {
            //校验成功则进行保存
            employeeService.saveEmp(employee);
            return Msg.success();
        }
    }

    /**
     * 检验用户名是否可用
     *
     * @param name 用户名
     * @return
     */
    @RequestMapping("checkUser")
    @ResponseBody
    public Msg checkUser(@RequestParam("empName") String name) {
        //先判断用户名是符合法
        String regex = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
        if (!name.matches(regex)) {
            return Msg.fail().add("va_msg", "用户名必须是6-16位数字和字母的组合或者2-5位中文");
        }

        //数据库用户名重复校验
        boolean b = employeeService.checkUser(name);
        return b ? Msg.success() : Msg.fail().add("va_msg", "用户名不可用");
//        if (b) {
//            return Msg.success();
//        } else {
//            return Msg.fail();
//        }
    }

    /**
     * 根据id查询员工
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "getEmp/{id}", method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("id") Integer id) {
        Employee emp = employeeService.getEmp(id);
        return Msg.success().add("emp", emp);
    }

    /**
     * 员工更新方法
     * Ajax发送put请求失效的问题:
     * 解决方案:需在web.xml中添加HttpPutFormContentFilter过滤器
     *
     * @param employee
     * @return
     */
    @RequestMapping(value = "updateEmp/{empId}", method = RequestMethod.PUT)
    @ResponseBody
    public Msg updateEmp(Employee employee, HttpServletRequest request) {
        String email = request.getParameter("email");
        System.out.println(email);
        System.out.println("将要更新的员工数据" + employee);
        //Employee{empId=6002, empName='null', gender='null', email='null', dId=null, department=null}
        employeeService.updateEmp(employee);
        return Msg.success();
    }

    /**
     * 根据id删除员工
     * @param id
     * @return
     */
//    @ResponseBody
//    @RequestMapping(value = "deleteEmp/{id}", method = RequestMethod.DELETE)
//    public Msg deleteEmp(@PathVariable("id") Integer id) {
//        employeeService.deleteEmp(id);
//        return Msg.success();
//    }

    /**
     * 单个删除,批量删除二合一
     * 根据id删除员工
     * 单个:1
     * 批量:1-2-3
     *
     * @param ids
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "deleteEmp/{ids}", method = RequestMethod.DELETE)
    public Msg deleteEmp(@PathVariable("ids") String ids) {
        //批量删除
        if (ids.contains("-")) {
            //组装id的集合
            List<Integer> list = new ArrayList<>();
            String[] idList = ids.split("-");
            for (String id : idList) {
                list.add(Integer.parseInt(id));
            }
            employeeService.deleteEmpBatch(list);
        } else {
            //单个删除
            int id = Integer.parseInt(ids);
            employeeService.deleteEmp(id);
        }
        return Msg.success();
    }
}
