CREATE TABLE [dbo].[Procedimento_Atributo_Lista] (
    [cd_procedimento]          INT          NOT NULL,
    [cd_procedimento_atributo] INT          NOT NULL,
    [cd_lista_valor]           VARCHAR (20) NOT NULL,
    [nm_lista_valor]           VARCHAR (20) NOT NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usuario]               DATETIME     NOT NULL,
    CONSTRAINT [PK_Procedimento_Atributo_Lista] PRIMARY KEY CLUSTERED ([cd_procedimento] ASC, [cd_procedimento_atributo] ASC, [cd_lista_valor] ASC) WITH (FILLFACTOR = 90)
);

