const mongoose = require('mongoose');
const dotenv = require('dotenv');
const argon2 = require('argon2');
const SuperAdmin = require('./models/SuperAdmin');

dotenv.config();

const seedSuperAdmin = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI);

    console.log('MongoDB connected for seeding...');

    const email = 'dhurva@acryonix.com';
    const password = 'cQAsV#e9hNhf_mB';

    // Hash password with argon2id
    const passwordHash = await argon2.hash(password, { type: argon2.argon2id });

    // Check if user already exists
    let admin = await SuperAdmin.findOne({ email });

    if (admin) {
      console.log('Superadmin user already exists in super_admins. Updating password.');
      admin.passwordHash = passwordHash;
      await admin.save();
      console.log('Superadmin user updated.');
    } else {
      admin = await SuperAdmin.create({
        fullName: 'Dhurva Bhatt',
        email: email,
        passwordHash: passwordHash,
      });
      console.log('Superadmin user created successfully in super_admins collection!');
    }

    process.exit();
  } catch (err) {
    console.error(err);
    process.exit(1);
  }
};

seedSuperAdmin();
