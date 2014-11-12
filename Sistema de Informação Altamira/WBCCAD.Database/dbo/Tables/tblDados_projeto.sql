CREATE TABLE [dbo].[tblDados_projeto] (
    [IdOpcao]               INT            IDENTITY (1, 1) NOT NULL,
    [DescricaoChave]        NVARCHAR (50)  NULL,
    [chaveValor]            NVARCHAR (255) NULL,
    [grupo]                 NVARCHAR (50)  NULL,
    [lista]                 NVARCHAR (MAX) NULL,
    [Alterar_no_projeto]    BIT            NOT NULL,
    [inativo]               BIT            NOT NULL,
    [codigochave]           NVARCHAR (50)  NULL,
    [Somente_administrador] BIT            NOT NULL,
    [Perfil]                NVARCHAR (50)  NULL,
    CONSTRAINT [PK_tblDados_projeto] PRIMARY KEY CLUSTERED ([IdOpcao] ASC)
);

