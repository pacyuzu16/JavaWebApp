package com.mycompany.javawebapp.model;

import java.sql.Timestamp;

public class Employee {
    private int id;
    private String name;
    private String email;
    private String country;
    private Timestamp deletedAt; // New field to track deletion timestamp

    public Employee() {}

    public Employee(String name, String email, String country) {
        this.name = name;
        this.email = email;
        this.country = country;
    }

    public Employee(int id, String name, String email, String country) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.country = country;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getCountry() { return country; }
    public void setCountry(String country) { this.country = country; }

    public Timestamp getDeletedAt() { return deletedAt; }
    public void setDeletedAt(Timestamp deletedAt) { this.deletedAt = deletedAt; }
}