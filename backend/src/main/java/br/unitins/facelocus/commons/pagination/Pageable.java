package br.unitins.facelocus.commons.pagination;

import jakarta.ws.rs.QueryParam;
import lombok.Getter;
import lombok.Setter;

import java.lang.reflect.Field;

@Setter
@Getter
public class Pageable {

    @QueryParam("page")
    private int page = 0;
    @QueryParam("size")
    private int size = Pagination.STANDARD_PAGE_SIZE;
    @QueryParam("sort")
    private String sort;

    /**
     * Campo para ser ordenado
     *
     * @return Campo
     */
    public String getByOrder() {
        if (this.sort != null) {
            if (this.sort.contains(",")) {
                String[] properties = this.sort.split(",");
                return properties[0];
            }
        }
        return "id";
    }

    /**
     * Campo para ser ordenado
     *
     * @return Campo
     */
    public String getByOrder(Class<?> clazz) {
        if (this.sort != null) {
            if (this.sort.contains(",")) {
                String[] properties = this.sort.split(",");
                if (fieldExists(clazz, properties[0])) {
                    return properties[0];
                }
            }
        }
        this.sort = getRandomFieldName(clazz);
        return sort;
    }

    /**
     * Ordem para paginação
     *
     * @return Ordem
     */
    public String getOrder() {
        if (this.sort != null) {
            if (this.sort.contains(",")) {
                String[] propriedades = this.sort.split(",");
                if (propriedades[1].equalsIgnoreCase("DESC"))
                    return propriedades[1].toUpperCase();
            }
        }
        return "ASC";
    }

    /**
     * Verifica em tempo de execução se o campo passado por query params existe na entidade. Caso não existe é definido
     *
     * @param clazz     Classe
     * @param fieldName Nome do campo
     * @return Verdadeiro se o campo passado como argumento existir na classe
     */
    boolean fieldExists(Class<?> clazz, String fieldName) {
        Field[] campos = clazz.getDeclaredFields();
        for (Field campo : campos) {
            if (campo.getName().equalsIgnoreCase(fieldName)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Pega um nome de qualquer campo da classe
     *
     * @param clazz Classe
     * @return Campo aleatorio da classe
     */
    String getRandomFieldName(Class<?> clazz) {
        Field[] campos = clazz.getDeclaredFields();
        for (Field campo : campos) {
            if (campo.getType().isArray()) {
                continue;
            }
            return campo.getName();
        }
        return "";
    }
}
