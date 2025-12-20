package com.todo.util;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class EmailService {

    // In a real application, these should be in a config file or environment
    // variables
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String USERNAME = "taskreminderservice@gmail.com"; // Placeholder
    private static final String PASSWORD = "emiwlwgvkukwljcg"; // Placeholder

    public static boolean sendEmail(String toAddress, String subject, String messageContent) {
        Properties prop = new Properties();
        prop.put("mail.smtp.host", SMTP_HOST);
        prop.put("mail.smtp.port", SMTP_PORT);
        prop.put("mail.smtp.auth", "true");
        prop.put("mail.smtp.starttls.enable", "true"); // TLS

        Session session = Session.getInstance(prop,
                new javax.mail.Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(USERNAME, PASSWORD);
                    }
                });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(USERNAME));
            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse(toAddress));
            message.setSubject(subject);
            message.setContent(messageContent, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("Email sent successfully to " + toAddress);
            return true;

        } catch (MessagingException e) {
            System.err.println("Failed to send email to " + toAddress + ": " + e.getMessage());
            return false;
        }
    }
}
