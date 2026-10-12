// Extensión pequeña para módulo 5: consulta interna del contador cada 30 segundos.
const contador = document.querySelector('#contador');
if (contador && contador.dataset.url) {
    const actualizarContador = async () => {
        try {
            const respuesta = await fetch(contador.dataset.url, {headers: {'Accept': 'application/json'}});
            if (!respuesta.ok || respuesta.redirected) return;
            const datos = await respuesta.json();
            contador.textContent = datos.cantidad;
        } catch (error) {
            // Mantener el último valor conocido si no hay conexión.
        }
    };
    setInterval(actualizarContador, 30000);
}
