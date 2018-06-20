# VirtualBox y Vagrant

Andrés Hernández

Universidad Nacional Autónoma de México

Facultad de Ciencias

Verano 2018

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />

--------

## Objetivo del curso

+ El alumno conocerá el sistema de virtualización Oracle VirtualBox y aprenderá como instalar el *software* en GNU/Linux.

+ También aprenderá a manejar, importar y exportar máquinas virtuales, así como instalar el software Hashicorp Vagrant que funciona como meta-manejador de máquinas virtuales y se utiliza para procesos de DevOps.


--------------------------------------------------------------------------------

## Temario (1)

1. Introducción a los sistemas de virtualizacion
   a. Hipervisores
   b. Máquinas virtuales
   c. Virtualización de aplicaciones
   d. Contenedores
   e. Virtualización anidada

--------

## Temario (2)

2. Introducción a Oracle VirtualBox
   a. Diferencias entre Oracle VirtualBox y otros productos de Virtualización
   b. Requerimientos de hardware y software en el host
   c. Sistemas operativos soportados en máquinas virtuales
   d. Dispositivos de hardware presentados a las máquinas virtuales

--------

## Temario (3)

3. Instalación de Oracle VirtualBox
   a. Descarga del software del sitio oficial
   b. Instalación del software en GNU/Linux
   c. Instalación de VirtualBox Extension Pack

--------

## Temario (4)

4. Creación de máquinas virtuales
   a. Crear una nueva máquina virtual
   b. Editar las propiedades de la máquina virtual
   c. Clonar una máquina virtual
   d. Borrar una máquina virtual
   e. Iniciar y detener una máquina virtual
   f. Modos de pantalla completa

--------

## Temario (5)

5. VirtualBox Guest Additions
   a. Instalación de VirtualBox Guest Additions en la máquina virtual
   b. Actualización de VirtualBox Guest Additions en la máquina virtual
   c. Compartir el portapapeles para copiar y pegar
   d. Compartir carpetas entre el anfitrión y la máquina virtual
   e. Conectar dispositivos USB a la máquina virtual

--------

## Temario (6)

6. Administración de máquinas virtuales
   a. Importar y exportar máquinas virtuales
   b. Administración de snapshots
   c. Configuración de acceso remoto
   d. Virtual Media Manager

--------

## Temario (7)

7. Configuración de las conexiones de red
   a. Tipos de conexiones de red
   b. Interfaces de red
   c. Virtual Network Editor

--------

## Temario (8)

8. Introducción a Hashicorp Vagrant
   a. Requisitos de software y hardware
   b. Descarga del software del sitio oficial
   c. Instalación de Vagrant en GNU/Linux

--------

## Temario (9)

9. Uso de Vagrant
   a. Inicialización de un directorio para vagrant
   b. Descargar e instanciar una máquina virtual con vagrant
   c. Sintáxis del archivo Vagrantfile
   d. Configuración de SSH y carpetas compartidas
   e. Administración de snapshots
   f. Redirección de puertos
   g. Configuración extra de red

--------------------------------------------------------------------------------

## 1. Introducción a los sistemas de virtualización

--------

### a. Hipervisores

Un *hipervisor* o *monitor de máquinas virtuales* (VMM) es un programa que ejecuta y administra los recursos para las *máquinas virtuales* que corren dentro del __servidor físico__ (*host*)

Existen dos tipos de *hipervisores* que se diferencían de acuerdo al contexto donde se ejecutan:

+ Tipo 1 - *Bare-Metal*
+ Tipo 2 - *Hosted*

--------

#### Tipo 1 - *Bare-Metal hypervisor*

+ Este tipo de *hipervisores* se ejecuta diréctamente sobre el *hardware* del __equipo físico__ (ring 0)
+ Utilizado en servidores
+ Como el *hipervisor* controla el *hardware* el rendimiento es mejor, pero el sistema únicamente se puede dedicar a correr máquinas virtuales
+ Implementa sus propias técnicas para el manejo de recursos (*scheduling*, *interrupts*, *DMA*, *drivers*, etc.)
+ Esta tecnología no es nueva, fue introducida por IBM en los 60's

--------

#### Tipo 2 - *Hosted hypervisor*

+ Este tipo de *hipervisores* se ejecuta sobre un sistema operativo instalado en el equipo (GNU/Linux, MacOS X, FreeBSD, Solaris, Windows, etc.)
+ Utilizado en *workstations*, equipos de escritorio y portátiles (*commodity hardware*)
+ Se ejecuta como una aplicación más en el sistema operativo (ring 3) y depende de los recursos que se asignen (CPU, memoria, acceso a disco y red, etc.)
+ El rendimiento es más lento, pero no es necesario dedicar el equipo únicamente a correr máquinas virtuales
+ Se pueden ejecutar varios *hipervisores* de tipo 2 al mismo tiempo en un equipo (ej. VirtualBox y VMware WorkStation o VMware Fusion)

--------

#### Ejemplos de *software*

| *Vendor*	| Type-1: *bare-metal* (ring 0)	| Type-2: *hosted* (ring 3) |
|:-------------:|:-----------------------------:|:--------:|
| Red Hat	| KVM				| KVM |
| FreeBSD	| `bhyve`			| `bhyve` |
| Citrix	| Xen				| - |
| Citrix	| XenServer			| - |
| Oracle	| VM Server			| VirtualBox |
| VMware	| ESX/ESXi <br/> vSphere	| Workstation / Fusion <br/> Player / Server |
| Parallels	| -				| Workstation / Desktop |
| Microsoft	| Hyper-V <br/> Client Hyper-V	| VirtualPC |
| *third-party*	| 				| `qemu` / `bochs` |

--------

#### Extensiones de virtualización

La mayoría del *software* de virtualización requiere que el CPU cuente con características especiales para poder realizar la traducción de direcciones (*IO-MMU virtualization*)

+ [`lm`] [Procesador con arquitectura de 64 bits](https://en.wikipedia.org/wiki/Long_mode)
+ [Extensiones de virtualización](https://en.wikipedia.org/wiki/X86_virtualization#Central_processing_unit)

    + [`svm`] AMD-V _Pacifica_ Athlon 64 FX Dual Core
    * [`vmx`] Intel VT-X _Vanderpool_ Core 2 Duo

* [SLAT - *Second Level Address Translation*](https://en.wikipedia.org/wiki/Second_Level_Address_Translation)

    * [`npt`] AMD-Vi AMD Phenom II X6 / Opteron _Barcelona_
    * [`ept`] Intel VT-d _Nehalem_ Core 2 Quad / Xeon E5

--------

##### Otras extensiones de virtualización

* *Interrupt virtualization*

    * AMD-AVIC _Carrizo_
    * Intel APICv _Ivy Bridge_

* *Network virtualization*

    * Intel VT-c *Virtualization Technology for Connectivity*

* SR-IOV - *PCI-SIG Single Root I/O Virtualization*

* *GPU Virtualization*

    * Intel Iris Pro: GVT-d, GVT-g y GVT-s

--------

### b. Máquinas virtuales

+ Son _instancias_ de sistemas operativos que se ejecutan dentro de un *hipervisor*
+ Tienen sus propios recursos asignados (vCPU, RAM, disco duro, etc.)
+ Al ejecutarse se abre una ventana que simula ser el monitor del equipo y se pueden utilizar el teclado y *mouse* para interactuar con el equipo
+ El *hipervisor* presenta una serie de dispositivos virtualizados que puede utilizar la _máquina virtual_ (*hardware* virtual)
+ El sistema operativo se instala desde un disco o se importa desde una imágen
+ Puede acceder diréctamente a la red (bridge) o simular que está detrás de un NAT

--------

### c. Virtualización de aplicaciones

+ Permite ejecutar una aplicación sin necesidad de instalarla en el sistema
+ La aplicación corre sobre un entorno que comprende los recursos del sistema mas los recursos simulados que provienen de la capa intermedia de _virtualización_
+ Comúnmente estas aplicaciones se distribuyen como un único archivo ejecutable
+ La capa de _virtualización_ intercepta las llamadas al disco para evitar escribir en el sistema _real_
+ Ejemplos de *software* para _virtualización de aplicaciones_:

    * VMware ThinApp
    * Citrix XenApp
    * Microsoft App-V

--------

### d. Contenedores

+ También conocidos como "jaulas con esteroides", virtualizan todo el sistema operativo excepto el kernel
+ Son más ligeros que las máquinas virtuales porque comparten todos los recursos del sistema operativo
+ Dependiendo la tecnología utilizada, las aplicaciones de los contenedores se ejecutan _lado a lado_ con el sistema operativo _real_
+ Ejemplos de *software* para contenedores:

    * OpenVZ
    * LXC
    * Virtuozzo
    * Solaris Zones and Containers
    * Docker
    * Kubernetes

--------

### e. Virtualización anidada (VT-in-VT)

+ Permite ejecutar un hypervisor dentro de otro
+ Necesita que el CPU cumpla con varios requisitos

    * Arquitectura de 64 bits (x86\_64 / amd64)
    * Tener extensiones de virtualización VT-x o AMD-V
    * Implementar algún mecanismo de SLAT (*Second Level Address Translation*) VT-d o AMD-Vi

+ Ejemplos de *software* que soportan virtualización anidada:

    * KVM
    * Xen 4.4+
    * Citrix XenServer
    * Oracle VM Server
    * VMware ESXi / vSphere / Workstation / Fusion
    * Microsoft Hyper-V *

+ Por desgracia VirtualBox [no soporta virtualización anidada](https://www.virtualbox.org/ticket/4032)
