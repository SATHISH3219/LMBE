package com.LMBE.LMBE.Producer;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/producer")
public class ProducerController {

    @GetMapping("/products")
    public String viewProducts() {
        // Your logic for returning producer products
        return "Producer Products";
    }
}
