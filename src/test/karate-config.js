function fn(){
    var config = {
    baseUrl: 'https://restful-booker.herokuapp.com',

    endpointAuth: '/auth',
    endpointBooking: '/booking',
    endpointPing: '/ping',
    username: 'admin',
    password: 'password123',
    authToken: 'Basic YWRtaW46cGFzc3dvcmQxMjM='
    };

    karate.configure('continueOnStepFailure', true);

    return config;
}