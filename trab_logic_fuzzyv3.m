%-----UTILIZAÇÃO DE LÓGICA FUZZY PARA PRECIFICAÇÃO DE CARROS USADOS
%-----André Tsuyoshi Hioki; Murilo Franco Coradini
%-----Data: 06/12/2021

clc
clear all

ano_atual = 2021;

%entradas vindas do usuário:
valorfipe = 43281; %Valor do carro pela tabela FIPE
kmrodado = 24648; %km rodados pelo veiculo em km
ano_modelo = 2019; %ano do modelo do carro
ind_estetica = 8; %indice da conservação estética
ind_itens = 8; %indice de conservação dos itens (pneus, sinalização e segurança)
doc = 10; %indice de historico e documentação (primeiro dono, multas e etc)


%manipulações;
idade = ano_atual - ano_modelo;
if idade == 0
    ind_kmidade = kmrodado;
elseif idade < 0
    msgbox('Idade negativa', 'Error','error');
else
    ind_kmidade = kmrodado/(idade);
end

ind_kmideal = ((ind_kmidade+(idade-1)*390)/12900)-1;

if ind_kmideal>2
    ind_kmideal=2;
end

fprintf('distancia da média nacional: %f%%\n', ind_kmideal*100);

input = [ind_kmideal ind_estetica ind_itens doc];

%Chamando o sistema fuzzy criado pela tool box
fispreco = readfis('trab_logic_toolv3');

%Solve do problema para nossas entradas
output = evalfis(input,fispreco);

%Saída dos resultados
if output > 0
    fprintf('valorização de %f%%\n',output); %retorna o resultado
else
    fprintf('desvalorização de %f%%\n',output); %retorna o resultado
end
fprintf('Precificação para venda: R$%.2f\n', valorfipe*(1+output/100))


figure(1) 
plotfis(fispreco); %plota o sistema inteiro
for i=1:4
    figure(i+1)
    plotmf(fispreco,'input',i) %plota as funções de pertinencia de entrada
end
figure(6)
plotmf(fispreco,'output',1) %plota a função de pertinencia de saída
figure(7)
gensurf(fispreco);

%showrule(fispreco)
