const register = async (req, res) => {
  const { fullName, phone, password } = req.body;

  res.status(201).json({
    message: "Registration endpoint ready",
    user: {
      fullName,
      phone,
    },
    nextStep: "Persist user and hash password",
  });
};

const login = async (req, res) => {
  const { phone } = req.body;

  res.json({
    message: "Login endpoint ready",
    user: {
      phone,
    },
    nextStep: "Validate credentials and issue JWT",
  });
};

module.exports = {
  register,
  login,
};

