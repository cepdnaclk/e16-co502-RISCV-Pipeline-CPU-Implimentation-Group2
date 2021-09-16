[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

<!-- PROJECT LOGO -->
<br />
<p align="center">
    <img src="https://upload.wikimedia.org/wikipedia/commons/9/9a/RISC-V-logo.svg" alt="Logo" width="200" height="100">

  <h1 align="center">e16-Co502-RISCV-Pipeline-CPU-Implimentation</h1>

  <p align="center">
    This is the RISC-V ISA implementation by Group 2 
    <br />
    <a href="https://github.com/cepdnaclk/e16-co502-RISCV-Pipeline-CPU-Implimentation-Group2"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/cepdnaclk/e16-co502-RISCV-Pipeline-CPU-Implimentation-Group2/issues">Report Bug</a>
    ·
  </p>
</p>

<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->

## About The Project

This is the RISC-V CPU implimentation using VERILOG_HDL.

### Built With

- [VERILOG HDL](https://en.wikipedia.org/wiki/Verilog)
- [C++]()

<!-- GETTING STARTED -->

## Getting Started

To get a local copy up and running follow these simple steps.

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/github_username/repo_name.git
   ```
2. Install Verilog
   ```sh
   sudo apt-get install iverilog
   ```
3. Install GDKwave
   ```sh
   sudo apt install gtkwave
   ```

<!-- USAGE EXAMPLES -->

## Usage

1. Navigate to folder
   ```sh
        cd CPU\ Testbench
   ```
2. Compile
   ```sh
        iverilog -o group2cpu.vvp RiscV_TB.v
   ```
3. Run
   ```sh
        vvp group2cpu.vvp
   ```
4. Open with GTKwave tool
   ```sh
        gtkwave cpu_wavedata.vcd
   ```

_This is tested with the verilog compiler version 10.3_

<!-- LICENSE -->

## License

Distributed under the MIT License. See `LICENSE` for more information.

<!-- CONTACT -->

## Contact

Isuru Lakshan - [@isuru](eng.isurulakshan@gmail.com) - email
Randika viraj - [@randika](eng.isurulakshan@gmail.com) - email

Project Link: [https://github.com/cepdnaclk/e16-co502-RISCV-Pipeline-CPU-Implimentation-Group2](https://github.com/cepdnaclk/e16-co502-RISCV-Pipeline-CPU-Implimentation-Group2)

<!-- ACKNOWLEDGEMENTS -->

## Acknowledgements

- [Dr. Isuru Nawinne]()
- [Dr. Mahanama Wickramasinghe]()

<!-- MARKDOWN LINKS & IMAGES -->

[contributors-shield]: https://img.shields.io/github/contributors/cepdnaclk/e16-co502-RISCV-Pipeline-CPU-Implimentation-Group2.svg?style=for-the-badge
[contributors-url]: https://github.com/cepdnaclk/e16-co502-RISCV-Pipeline-CPU-Implimentation-Group2/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/cepdnaclk/e16-co502-RISCV-Pipeline-CPU-Implimentation-Group2.svg?style=for-the-badge
[forks-url]: https://github.com/cepdnaclk/e16-co502-RISCV-Pipeline-CPU-Implimentation-Group2/network/members
[stars-shield]: https://img.shields.io/github/stars/cepdnaclk/e16-co502-RISCV-Pipeline-CPU-Implimentation-Group2.svg?style=for-the-badge
[stars-url]: https://github.com/cepdnaclk/e16-co502-RISCV-Pipeline-CPU-Implimentation-Group2/stargazers
[issues-shield]: https://img.shields.io/github/issues/cepdnaclk/e16-co502-RISCV-Pipeline-CPU-Implimentation-Group2.svg?style=for-the-badge
[issues-url]: https://github.com/cepdnaclk/e16-co502-RISCV-Pipeline-CPU-Implimentation-Group2/issues
[license-shield]: https://img.shields.io/github/license/cepdnaclk/e16-co502-RISCV-Pipeline-CPU-Implimentation-Group2.svg?style=for-the-badge
[license-url]: https://github.com/cepdnaclk/e16-co502-RISCV-Pipeline-CPU-Implimentation-Group2/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/github_username
