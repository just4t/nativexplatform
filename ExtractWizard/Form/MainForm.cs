﻿using ExtractWizard.Gateway;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ExtractWizard
{
    public partial class MainForm : Form
    {
        private Controller.MainForm _controller;

        public MainForm()
        {
            InitializeComponent();

            // Create the Gateway to this View
            MainFormGateway gateway = new MainFormGateway(this);
            // Create the Controller
            _controller = new Controller.MainForm(gateway);
        }

        private void MainForm_Load(object sender, EventArgs e)
        {
            // Ask the Controller to initialize the View
            _controller.IntializeView();
        }
    }
}
