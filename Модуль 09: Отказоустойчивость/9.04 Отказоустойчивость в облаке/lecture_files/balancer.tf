resource "yandex_lb_target_group" "web_tg" {
  name      = "web-target-group-${var.flow}"
  region_id = "ru-central1"

  target {
    subnet_id = yandex_vpc_subnet.develop_a.id
    address   = yandex_compute_instance.web[0].network_interface.0.ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.develop_a.id
    address   = yandex_compute_instance.web[1].network_interface.0.ip_address
  }
}

resource "yandex_lb_network_load_balancer" "web_lb" {
  name = "web-load-balancer-${var.flow}"

  listener {
    name = "http-listener"
    port = 80

    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.web_tg.id

    healthcheck {
      name = "http-healthcheck"

      http_options {
        port = 80
        path = "/"
      }
    }
  }
}