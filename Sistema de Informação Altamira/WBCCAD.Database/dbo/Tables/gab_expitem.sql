CREATE TABLE [dbo].[gab_expitem] (
    [Item]                      SMALLINT       NULL,
    [Tipo]                      NVARCHAR (100) NULL,
    [X]                         FLOAT (53)     NULL,
    [Y]                         FLOAT (53)     NULL,
    [Grupo]                     NVARCHAR (100) NULL,
    [Alinhamento]               NVARCHAR (50)  NULL,
    [Pormod]                    BIT            NULL,
    [Medida]                    FLOAT (53)     NULL,
    [Modelo]                    NVARCHAR (50)  NULL,
    [NAO_INCLUIR_COTA]          BIT            NULL,
    [inicio]                    BIT            NULL,
    [final]                     BIT            NULL,
    [I_inicio]                  BIT            NULL,
    [I_final]                   BIT            NULL,
    [I_somente_inicio_vazio]    BIT            NULL,
    [I_somente_final_vazio]     BIT            NULL,
    [I_somente_inicio_gabinete] BIT            NULL,
    [I_somente_final_gabinete]  BIT            NULL
);

