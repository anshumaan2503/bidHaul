import '../models/platform_user.dart';

final List<PlatformUser> dummyPlatformUsers = [
  const PlatformUser(
    userId: "1",
    name: "ABC Logistics Pvt Ltd",
    email: "abc@gmail.com",
    phone: "+91 9876543210",
    type: UserType.company,
    status: UserStatus.active,
  ),
  const PlatformUser(
    userId: "2",
    name: "Fast Freight",
    email: "fast@gmail.com",
    phone: "+91 9988776655",
    type: UserType.transporter,
    status: UserStatus.active,
  ),
  const PlatformUser(
    userId: "3",
    name: "Cargo King",
    email: "cargo@gmail.com",
    phone: "+91 9876501234",
    type: UserType.transporter,
    status: UserStatus.suspended,
  ),
];
