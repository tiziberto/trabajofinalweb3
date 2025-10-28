package ar.edu.iua.iw3.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ar.edu.iua.iw3.model.Orden;
import ar.edu.iua.iw3.model.business.BusinessException;
import ar.edu.iua.iw3.model.business.FoundException;
import ar.edu.iua.iw3.model.business.IOrdenBusiness;
import ar.edu.iua.iw3.util.IStandartResponseBusiness;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.PostConstruct;

@RestController
@RequestMapping("/api/v1/ordenes") // <-- HARDCODEAMOS la URL para descartar Constants.java
@Tag(description = "API para la administración de Órdenes de Carga", name = "Orden")
public class OrdenRestController extends BaseRestController {

    /*
    @Autowired // <-- COMENTAR TEMPORALMENTE
    private IOrdenBusiness ordenBusiness;
    
    @Autowired // <-- COMENTAR TEMPORALMENTE
    private IStandartResponseBusiness response;
    */

    // Endpoint de prueba simple
    @PostMapping(value = "")
    public ResponseEntity<?> add(/* @RequestBody Orden orden */) { // <-- COMENTAR EL BODY
        // Devolvemos un 200 OK simple con un mensaje
        return new ResponseEntity<>("Endpoint de Ordenes funcionando!", HttpStatus.OK); 
    }
}