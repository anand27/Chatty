package com.tutorialspoint;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name="groups")
public class Groups {
	
	@Id
	@Column(name="name")
	private String groupname;
	
	@Column(name="numberofusers")
	private int users;
	
	public Groups()
	{
		
	}

	public Groups(String groupname, int users) {
		this.groupname = groupname;
		this.users = users;
	}

	public String getGroupname() {
		return groupname;
	}

	public void setGroupname(String groupname) {
		this.groupname = groupname;
	}

	public int getUsers() {
		return users;
	}

	public void setUsers(int users) {
		this.users = users;
	}

}
