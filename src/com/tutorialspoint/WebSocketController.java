package com.tutorialspoint;

import org.springframework.security.authentication.*;
import org.springframework.security.core.*;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.session.SessionRegistry;

import java.security.Principal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.messaging.simp.annotation.SubscribeMapping;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.sun.jmx.snmp.Timestamp;


@Controller
public class WebSocketController {
	
	
	@Autowired
	public SimpMessagingTemplate template;
	
	@Autowired
	public SessionFactory factory;
	
	@Autowired
	protected AuthenticationManager authenticationManager;
	
	@Autowired
	@Qualifier("sessionRegistry")
	private SessionRegistry sessionRegistry;
	
	@MessageMapping("/send3")//sending message
	public void send3(ReceiveMessage message,Principal principal) throws Exception {
		       
		if(message.isGroup())
		{
			this.template.convertAndSend("/topic/"+message.getReceiver_name(), "(From "+principal.getName()+" in group "+message.getReceiver_name()+ " ):"+ message.getText());
			return;
		}
		if(!principal.getName().equals(message.getReceiver_name()))
       	{this.template.convertAndSendToUser(message.getReceiver_name(), "/queue/private", principal.getName()+" : "+message.getText());
      	this.template.convertAndSendToUser(principal.getName(), "/queue/private", principal.getName()+" : "+message.getText());
	}
	}
	
	
	@MessageMapping("/send5")//for creating groups
	public void send5(String name,Principal principal) throws Exception {
		         		
		Session session = factory.openSession();
		session.beginTransaction();
		User_groups temp = new User_groups(principal.getName(),name);
		session.save(temp);
		session.getTransaction().commit();
		session.close();
		showGroups();
	}
	
	@MessageMapping("/send6")//for leaving group
	public void send6(String name,Principal principal) throws Exception {
		           
		Session session = factory.openSession();
		Query q = session.createQuery("FROM User_groups s where s.username=:name and s.groupname=:groupname");
	   	q.setParameter("name", principal.getName());
	   	q.setParameter("groupname", name);
	   	
	   	User_groups group = (User_groups)q.uniqueResult();
		session.beginTransaction();
		session.delete(group);
		session.getTransaction().commit();
		session.close();
		showGroups();
	}
	
	
	@MessageMapping("/send7")//for showing available groups
	public void send7(Principal principale) throws Exception {
	
		showGroups();
	}
	
	@MessageMapping("/send9")//for showing available groups(new approach) - for joined only
	public void send9(Principal principal) throws Exception {
		
		List<String> groupnames = new ArrayList<String>();
		
		Session session = factory.openSession();
		Query q = session.createQuery("FROM User_groups s where s.username=:name");
		q.setParameter("name", principal.getName());
	   	List<User_groups> groups = q.list();
	   	for(User_groups group:groups)
	   	{
	   		groupnames.add(group.getGroupname());
		}
		String names = Arrays.toString(groupnames.toArray());
		session.close();
		this.template.convertAndSendToUser(principal.getName(), "/queue/groupnames", names);
	}

	private void showGroups() {
		
		List<String> groupnames = new ArrayList<String>();
		Session session = factory.openSession();
		Query q = session.createQuery("FROM User_groups");
		List<User_groups> groups = q.list();
	   	for(User_groups group:groups)
	   	{
	   		if(!groupnames.contains(group.getGroupname()))
	   		groupnames.add(group.getGroupname());
		}
		String names = Arrays.toString(groupnames.toArray());
		session.close();
		this.template.convertAndSend("/topic/publicgroups",names);
	}
	
	@MessageMapping("/send8")//for showing online users using topics
	public void send8(Principal principal) throws Exception {
		
		
		String usersNamesList = getUsers();
		System.out.println(usersNamesList);
 		this.template.convertAndSend("/topic/public",usersNamesList);
		
		/*if(!users.contains(principal.getName()))
		{
			users.add(principal.getName());
		}
		String usersNamesList = Arrays.toString(users.toArray());
		this.template.convertAndSend("/topic/public",usersNamesList);*/
	}
	
	@RequestMapping("/dummy-queue")
    public String chat_start3(Model model,Principal principale) {
        model.addAttribute("username", principale.getName());
		return "dummy-queue";
    }
	
    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String logout(HttpServletRequest request,
            HttpServletResponse response,Principal principal) {
        Authentication auth = SecurityContextHolder.getContext()
                .getAuthentication();
        if (auth != null) {
            new SecurityContextLogoutHandler().logout(request, response, auth);
        }
        
        /*if(users.contains(principal.getName()))
		{
			users.remove(principal.getName());
		}
		String usersNamesList = Arrays.toString(users.toArray());
		this.template.convertAndSend("/topic/public",usersNamesList);*/
		
        String usersNamesList = getUsers();
 		this.template.convertAndSend("/topic/public",usersNamesList);
      
 		return "redirect:/dummy-queue";
    }

	private String getUsers() {
		List<Object> principals = sessionRegistry.getAllPrincipals();
 		String usersNamesList = "";
 		for (Object principal: principals) {
 		    if (principal instanceof User) {
 		    		usersNamesList=((User) principal).getUsername()+"<br />"+usersNamesList;
  		   //System.out.println(usersNamesList);
 		    }
 		}
 		
		return usersNamesList;
	}
    
    @RequestMapping("/login")
    public String loginPage()
    {    
    	return"login";
    }
    @RequestMapping("/register")
    public String registerPage()
    {
    	return "registration";
    }
    
    @RequestMapping(value="/registration", method=RequestMethod.POST)
    public String registerPage2(@RequestParam Map<String,String> requestParams,Model model,HttpServletRequest request2,
            HttpServletResponse response2)
    {    	
    	String username = requestParams.get("username");
    	String password = requestParams.get("password");
    	String password2 = requestParams.get("password2");
    	if(!password.equals(password2))
    	{
    		model.addAttribute("error", "Passwords do not match");
    		return "registration";
    	}
    	Session session = factory.openSession();
    	Query q = session.createQuery("FROM Users s where s.username=:name");
    	q.setParameter("name", username);
    	Users user = (Users)q.uniqueResult();
    	if(user!=null)
    	{
    		model.addAttribute("error", "User already exists");
    		session.close();
    		return "registration";
    	}
        Users temp = new Users(username,password);
		session.beginTransaction();
		session.save(temp);
		session.getTransaction().commit();
		session.close();	
    	model.addAttribute("username",username);
		
    	SecurityContext context = SecurityContextHolder.getContext();
    	Authentication request = new UsernamePasswordAuthenticationToken(username, password);
        Authentication result = authenticationManager.authenticate(request);
        context.setAuthentication(result);
        
        sessionRegistry.registerNewSession(request2.getSession().getId(), context.getAuthentication().getPrincipal());
        
       /* try {
			request2.login(username, password);
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
        
        return "redirect:/dummy-queue";
    }
    
    public static void main(String[] args) {
    	  System.out.println("MySQL Connect Example.");
    	  Connection conn = null;
    	  String url = "jdbc:mysql://64.62.133.242:3306/";
    	  String dbName = "mydb";
    	  String driver = "com.mysql.jdbc.Driver";
    	  String userName = "root"; 
    	  String password = "GQPriq49963";
    	  try {
    	  Class.forName(driver).newInstance();
    	  conn = DriverManager.getConnection(url+dbName,userName,password);
    	  System.out.println("Connected to the database");
    	  conn.close();
    	  System.out.println("Disconnected from database");
    	  } catch (Exception e) {
    	  e.printStackTrace();
    	  }
    	  }
}