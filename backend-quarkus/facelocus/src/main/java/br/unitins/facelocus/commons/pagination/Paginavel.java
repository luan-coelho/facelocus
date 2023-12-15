package br.unitins.facelocus.commons.pagination;

import lombok.Getter;
import lombok.Setter;

import jakarta.ws.rs.QueryParam;
import java.lang.reflect.Field;

@Setter
@Getter
public class Paginavel {

    @QueryParam("page")
    private int pagina = 0;
    @QueryParam("size")
    private int tamanho = Paginacao.TAMANHO_PADRAO_PAGINACAO;
    @QueryParam("sort")
    private String ordenacao;

    /**
     * Campo para ser ordenado
     *
     * @return Campo
     */
    public String pegarCampoOrdenacao() {
        if (this.ordenacao != null) {
            if (this.ordenacao.contains(",")) {
                String[] properties = this.ordenacao.split(",");
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
    public String pegarCampoOrdenacao(Class<?> clazz) {
        if (this.ordenacao != null) {
            if (this.ordenacao.contains(",")) {
                String[] properties = this.ordenacao.split(",");
                if (campoExiste(clazz, properties[0])) {
                    return properties[0];
                }
            }
        }
        this.ordenacao = pegarNomeCampoAleatoriamente(clazz);
        return ordenacao;
    }

    /**
     * Ordem para paginação
     *
     * @return Ordem
     */
    public String pegarOrdem() {
        if (this.ordenacao != null) {
            if (this.ordenacao.contains(",")) {
                String[] propriedades = this.ordenacao.split(",");
                if (propriedades[1].equalsIgnoreCase("DESC"))
                    return propriedades[1].toUpperCase();
            }
        }
        return "ASC";
    }

    /**
     * Verifica em tempo de execução se o campo passado por query params existe na entidade. Caso não existe é definido
     *
     * @param clazz Classe
     * @param fieldName Nome do campo
     * @return Verdadeiro se o campo passado como argumento existir na classe
     */
    boolean campoExiste(Class<?> clazz, String fieldName) {
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
     * @param clazz Classe
     * @return Campo aleatorio da classe
     */
    String pegarNomeCampoAleatoriamente(Class<?> clazz) {
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
