CREATE TABLE [dbo].[ATDAUX] (
    [Número]                           INT             NOT NULL,
    [Origem]                           NVARCHAR (6)    NULL,
    [Data do Cadastro]                 DATE            NULL,
    [Data e Hora]                      DATETIME        NOT NULL,
    [Usuário]                          NVARCHAR (20)   NULL,
    [Identificador do Cliente]         INT             NOT NULL,
    [Logradouro]                       NVARCHAR (3)    NULL,
    [Endereço]                         NVARCHAR (50)   NULL,
    [Número do Endereço]               NVARCHAR (10)   NULL,
    [Complemento do Endereço]          NVARCHAR (30)   NULL,
    [Bairro]                           NVARCHAR (30)   NULL,
    [CEP]                              NVARCHAR (9)    NULL,
    [Cidade]                           NVARCHAR (30)   NULL,
    [Estado]                           NCHAR (2)       NULL,
    [Nome Fantasia]                    NVARCHAR (20)   NULL,
    [Razão Social]                     NVARCHAR (50)   NULL,
    [Código do Contato]                SMALLINT        NULL,
    [Nome do Contato]                  NVARCHAR (40)   NULL,
    [DDD do Telefone do Contato]       CHAR (3)        NULL,
    [Telefone do Contato]              NVARCHAR (15)   NULL,
    [Ramal do Telefone do Contato]     NVARCHAR (5)    NULL,
    [DDD do Fax do Contato]            NCHAR (3)       NULL,
    [Fax do Contato]                   NVARCHAR (15)   NULL,
    [Ramal do Fax do Contato]          NCHAR (5)       NULL,
    [DDD do Celular do Contato]        NCHAR (3)       NULL,
    [Celular do Contato]               NVARCHAR (15)   NULL,
    [Departamento]                     NVARCHAR (35)   NULL,
    [Cargo]                            NVARCHAR (30)   NULL,
    [Email]                            NVARCHAR (100)  NULL,
    [Código do Representante]          NCHAR (3)       NULL,
    [Nome do Representante]            NVARCHAR (30)   NULL,
    [Código do Tipo de Atendimento]    INT             NULL,
    [Descrição do Tipo de Atendimento] NVARCHAR (100)  NULL,
    [Código da Situação]               INT             NULL,
    [Descrição da Situação]            NVARCHAR (100)  NULL,
    [Código da Mídia]                  INT             NULL,
    [Descrição da Mídia]               NVARCHAR (100)  NULL,
    [Observações]                      NVARCHAR (2000) NULL,
    [Mensagem SMS]                     NVARCHAR (1000) NULL,
    [SMS Enviado]                      NCHAR (1)       NULL,
    [Usuário que Envio SMS]            NVARCHAR (20)   NULL,
    [Data e Hora do Envio]             DATETIME        NULL,
    [SMS Ok]                           NCHAR (1)       NULL
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[ATDAUX] TO [altanet]
    AS [dbo];

