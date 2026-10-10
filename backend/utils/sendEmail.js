const nodemailer = require('nodemailer');

const sendEmail = async (options) => {
  // 1) Create a transporter
  // For development, we use Ethereal Email which intercepts emails and gives a URL to view them.
  let transporter;
  
  if (process.env.SMTP_HOST) {
    // Production / Custom SMTP setup
    transporter = nodemailer.createTransport({
      host: process.env.SMTP_HOST,
      port: process.env.SMTP_PORT,
      auth: {
        user: process.env.SMTP_EMAIL,
        pass: process.env.SMTP_PASSWORD,
      },
    });
  } else {
    // Development fallback using Ethereal Email (Automatically generates an account)
    let testAccount = await nodemailer.createTestAccount();
    transporter = nodemailer.createTransport({
      host: 'smtp.ethereal.email',
      port: 587,
      secure: false,
      auth: {
        user: testAccount.user,
        pass: testAccount.pass,
      },
    });
  }

  // 2) Define the email options
  const message = {
    from: `${process.env.FROM_NAME || 'HRMS Admin'} <${process.env.FROM_EMAIL || 'noreply@hrms.com'}>`,
    to: options.email,
    subject: options.subject,
    text: options.message,
    html: options.html,
  };

  // 3) Actually send the email
  const info = await transporter.sendMail(message);

  // If using ethereal email for testing, log the URL so the developer can click and see it!
  if (!process.env.SMTP_HOST) {
    console.log('✉️  EMAIL SENT!');
    console.log('Preview URL: %s', nodemailer.getTestMessageUrl(info));
  }
};

module.exports = sendEmail;
