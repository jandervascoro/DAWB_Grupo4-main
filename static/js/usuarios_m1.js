const formularioUsuario = document.querySelector('#formUsuario');
if (formularioUsuario) {
    const password = document.querySelector('#password');
    const confirmar = document.querySelector('#confirm_password');
    const error = document.querySelector('#errorPassword');
    const validar = () => {
        const mensaje = password.value !== confirmar.value ? 'Las contraseñas no coinciden.' : '';
        confirmar.setCustomValidity(mensaje);
        error.textContent = mensaje;
    };
    password.addEventListener('input', validar);
    confirmar.addEventListener('input', validar);
}
